# frozen_string_literal: true

module Mermaid
  # Module containing Mermaid rendering logic for Diagrams::GitgraphDiagram
  module GitgraphDiagramRenderer
    # @!method to_mermaid
    #   Generates the Mermaid syntax for the gitgraph diagram.
    #   @return [String] The Mermaid syntax string.
    def to_mermaid
      mermaid_string = +"gitGraph\n"
      processed_commits = Set.new
      current_mermaid_branch = nil # Track the current branch in Mermaid output (defaults to 'master')

      # Determine initial branch (default to 'main') and add checkout
      first_commit_id = commit_order.first
      # Default to 'main' if no commits or first commit doesn't specify branch
      # Default to 'main' if no commits exist or first commit doesn't specify branch
      initial_branch = (first_commit_id ? commits[first_commit_id]&.branch_name : nil) || 'master' # Default to 'master'
      mermaid_string << "  checkout #{initial_branch}\n"
      current_mermaid_branch = initial_branch

      commit_order.each do |commit_id|
        commit = commits[commit_id]
        next unless commit # Skip if commit data is missing

        # --- Determine Branch Context ---
        commit.branch_name

        # --- Handle Branch Creation & Checkout ---
        # Determine the branch this commit *should* be on based on its branch_name attribute
        target_branch_name = commit.branch_name

        # Check if a new branch *starts* at this commit's parent
        parent_commit_id = commit.parent_ids.first
        new_branch_starting_here = nil
        # Only consider branching if the target is NOT master and IS different from current
        if parent_commit_id && target_branch_name != 'master' && target_branch_name != current_mermaid_branch
          # Check if a branch object exists that starts at the parent and matches the target name
          new_branch_starting_here = branches.values.find do |b|
            b.start_commit_id == parent_commit_id && b.name == target_branch_name
          end
        end

        if new_branch_starting_here
          # Ensure we are on the parent branch before creating the new one
          parent_commit = commits[parent_commit_id]
          parent_branch_name = parent_commit&.branch_name
          if parent_branch_name && parent_branch_name != current_mermaid_branch
            mermaid_string << "  checkout #{parent_branch_name}\n"
            current_mermaid_branch = parent_branch_name
          end
          mermaid_string << "  branch #{target_branch_name}\n"
          # No checkout here, the next check handles it
        end

        # Now, handle checkout if needed for the current commit
        if target_branch_name != current_mermaid_branch
           # Always checkout if the branch differs from the last known Mermaid branch
           mermaid_string << "  checkout #{target_branch_name}\n"
           current_mermaid_branch = target_branch_name
        end

        # --- Handle Merge ---
        if commit.type == :MERGE && commit.parent_ids.length == 2 && !processed_commits.include?(commit_id)
          # Identify both parents
          parent1_id = commit.parent_ids[0]
          parent2_id = commit.parent_ids[1]
          parent1_commit = commits[parent1_id]
          parent2_commit = commits[parent2_id]

          # Find the parent commit whose branch is NOT the current branch
          source_commit = if parent1_commit&.branch_name != current_mermaid_branch
                            parent1_commit
                          elsif parent2_commit&.branch_name != current_mermaid_branch
                            parent2_commit
                          end
          source_branch_name = source_commit&.branch_name

          # Ensure source branch is valid and different from target
          if source_branch_name && source_branch_name != current_mermaid_branch
            mermaid_string << "  merge #{source_branch_name}"
            mermaid_string << " id: \"#{commit.id}\""
            mermaid_string << " tag: \"#{commit.tag}\"" if commit.tag
            mermaid_string << "\n"
            processed_commits.add(commit_id)
          else
            # If source branch can't be determined, generate a regular commit as fallback
            warn "Could not determine source branch for merge commit #{commit_id}. Generating standard commit."
            generate_commit_line(mermaid_string, commit, processed_commits) unless processed_commits.include?(commit_id)
          end

        # --- Handle Standard Commit ---
        elsif !processed_commits.include?(commit_id)
          generate_commit_line(mermaid_string, commit, processed_commits)
        end
      end

      mermaid_string.strip
    end

    private

    # Helper to generate a standard commit line
    def generate_commit_line(mermaid_string, commit, processed_commits)
      mermaid_string << '  commit'
      mermaid_string << " id: \"#{commit.id}\""
      mermaid_string << " tag: \"#{commit.tag}\"" if commit.tag
      mermaid_string << " type: #{commit.type.to_s.upcase}" unless commit.type == :NORMAL
      # Mermaid doesn't directly support messages in the command, they appear on the graph
      mermaid_string << "\n"
      processed_commits.add(commit.id)
    end
  end
end
