# frozen_string_literal: true

# Set environment to test
ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start do
  add_filter '/test/' # Exclude test directory itself
end

require 'minitest/autorun'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(color: true)]

require 'capybara/minitest'
require 'capybara/cuprite'
require 'tempfile'
require 'cgi'

require 'mermaid'

# Capybara configuration
Capybara.default_driver = :cuprite
Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    # Increase timeout for slower CI environments if needed
    # process_timeout: 15,
    # inspector: true, # Enable browser inspector for debugging
    headless: !ENV['HEADFUL'] # Run headful if HEADFUL env var is set
  )
end

# Base test class for Capybara integration tests
class IntegrationTest < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  # Setup to capture browser errors before each test
  def setup
    @browser_errors = []
    # Subscribe to console errors via the browser object using a block
    page.driver.browser.on('console') { |msg| handle_console_message(msg) }
    # Subscribe to page load errors via the browser object using a block
    page.driver.browser.on('pageerror') { |error| handle_page_error(error) }
  end

  def teardown
    # Unsubscribe or reset if necessary, though Capybara reset might handle it
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  # Helper to render Mermaid syntax and check for errors in a headless browser.
  # Returns true if rendering succeeds without JS errors, false otherwise.
  def render_mermaid_and_check_errors(mermaid_syntax)
    temp_html_file = create_temp_html(mermaid_syntax)
    visit("file://#{temp_html_file.path}")

    svg_rendered = wait_for_mermaid_svg
    errors_found = check_browser_logs_for_errors

    # Report specific failure reason
    puts "\nMermaid SVG element not found after waiting." unless svg_rendered
    puts "\nJavaScript errors detected during Mermaid rendering." if errors_found

    # Return true only if SVG rendered AND no errors were found
    svg_rendered && !errors_found
  ensure
    temp_html_file&.unlink # Clean up temp file if it exists
  end

  private

  # Creates a temporary HTML file containing the Mermaid syntax.
  # @param mermaid_syntax [String] The Mermaid syntax to render.
  # @return [Tempfile] The temporary file object.
  def create_temp_html(mermaid_syntax)
    html_content = <<~HTML
      <!DOCTYPE html>
      <html>
      <head>
        <title>Mermaid Test</title>
        <script src="https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.min.js"></script>
        <script>mermaid.initialize({ startOnLoad: true });</script>
      </head>
      <body>
        <div class="mermaid">
          #{CGI.escapeHTML(mermaid_syntax)}
        </div>
        <script>document.body.classList.add('mermaid-rendered');</script>
      </body>
      </html>
    HTML
    temp_file = Tempfile.new(['mermaid_test', '.html'])
    temp_file.write(html_content)
    temp_file.close
    temp_file
  end

  # Waits for the Mermaid SVG element to appear on the page.
  # @return [Boolean] True if the SVG element is found within the timeout, false otherwise.
  # Increased timeout to 10 seconds
  def wait_for_mermaid_svg(timeout: 10)
    assert_selector('div.mermaid svg', wait: timeout)
    true # SVG found
  rescue Capybara::ElementNotFound
    false # SVG not found
  end

  # Checks the collected browser errors.
  # @return [Boolean] True if errors were captured, false otherwise.
  def check_browser_logs_for_errors
    return false if @browser_errors.empty?

    warn "\n[TEST HELPER] JavaScript/Browser errors detected:\n#{@browser_errors.join("\n")}"
    true # Errors found
  end

  # Callback for Cuprite console messages
  def handle_console_message(msg)
    # Capture errors or specific message types
    # Example: Capture only 'error' level messages
    return unless msg.type == 'error' || msg.level == 'severe' # Adjust condition as needed

    @browser_errors << "Console [#{msg.type}/#{msg.level}]: #{msg.text}"

    # You could also capture warnings, logs, etc.
    # puts "Console [#{msg.type}/#{msg.level}]: #{msg.text}" # For debugging
  end

  # Callback for Cuprite page errors (uncaught JS exceptions)
  def handle_page_error(error)
    @browser_errors << "Page Error: #{error.message}"
    # puts "Page Error: #{error.message}\n#{error.stack}" # For debugging
  end
end

# Base test class for standard unit tests
class UnitTest < Minitest::Test
  # Add any common setup/teardown for unit tests here
end
