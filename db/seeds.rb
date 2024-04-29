# frozen_string_literal: true

load Rails.root.join('lib/tasks/story-cli/seeds.thor')

# load_cli_script 'seeds', ext: :thor

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

StoryCLI::Seeds.new.invoke(:load, [])
