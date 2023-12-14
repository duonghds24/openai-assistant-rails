# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

org1 = Organisation.create(org_name: "EH1")
org2 = Organisation.create(org_name: "EH2")

Member.create(organisation: org1, member_name: "Duong Hoang", role: "admin")
Member.create(organisation: org1, member_name: "Brendon Dao")
Member.create(organisation: org2, member_name: "Phien Pham")
Member.create(organisation: org2, member_name: "An Chu")
Member.create(organisation: org2, member_name: "Bao Dinh")
