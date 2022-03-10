# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

users = User.create([
                      { name: 'Bob' },
                      { name: 'Sally' },
                      { name: 'Joe' }
                    ])

users.each do |user|
  user.documents.create([
                          {  body: "This is a document for #{user.name}" },
                          {  body: "This is another document for #{user.name}" },
                          {  body: "This is a third document for #{user.name}" },
                          {  body: "This is a fourth document for #{user.name}" }
                        ])
end
