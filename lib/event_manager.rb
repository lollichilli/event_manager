# # Switching over to use the csv library
# require "csv"
# require "google/apis/civicinfo_v2"




# # Moving Clean Zip Codes to a Method
# def clean_zipcode(zipcode)
#     zipcode.to_s.rjust(5, "0")[0..4]
# end



# # contents = File.read('event_attendees.csv')
# # puts contents

# # lines = File.readlines('event_attendees.csv')
# # # lines.each do |line|
# # #     columns = line.split(",")
# # #     first_name = columns[2]
# # #     puts first_name
# # #     # puts line
# # # end

# # # Skipping the header row by next if
# # # Second Approach: use the row index
# # # Third Approach: use the each_with_index

# # row_index = 0
# # lines.each_with_index do |line, index|
# #     # Approach 1: 
# #     # next if line == " ,RegDate,first_Name,last_Name,Email_Address,HomePhone,Street,City,State,Zipcode\n"

# #     # Approach 2:
# #     # row_index = row_index + 1
# #     # next if row_index == 1

# #     # Approach 3:
# #     next if index == 0


# #     columns = line.split(",")
# #     first_name = columns[2]
# #     puts first_name
# # end

# # Switching over to use the csv library
# # contents = CSV.open("event_attendees.csv", headers: true)
# # contents.each do |row|
# #     puts
# #     name = row[2]
# #     puts name
# # end

# # Accessing Columns by their Names

# def legislators_by_zipcode(zip)
#     civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
# civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw' 

#     begin
#         legislators = civic_info.representative_info_by_address(
#             address: zipcode,
#             levels: 'country',
#             roles: ['legislatorUpperBody', 'legislatorLowerBody']
#         )

#         legislators = legislators.officials
#         legislator_names = legislators.map(&:name)
#         legislators_string = legislator_names.join(", ")
#     rescue
#         'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
#     end

#     # legislator_names = legislators.map do |legislator|
#     #     legislator.name
#     # end

#     # Another way

# end

# puts  "Event Manager Initialized!"

# # Refactoring Clean Zip codes
# # A good rule is to favor coercing values into similar values => they can behave the same

# contents = CSV.open(
#     "event_attendees.csv", 
#     headers: true,
#     header_converters: :symbol
# )



# contents.each do |row|
#     # name = row[:first_name]

#     # Display the zipcode
#     name = row[:first_name]
   

#     # Cleaning up your zipcode
#     # Problems:
#     # if zipcode == 5, OK
#     # if zipcode > 5, truncate to the first 5 digits
#     # if zipcode < 5, add 0s to the front till its length = 5
#     zipcode = clean_zipcode(row[:zipcode])

#     legislators = legislators_by_zipcode(zipcode)
#     puts "#{name}, #{zipcode}, #{legislators}"
# end

require 'csv'
require 'google/apis/civicinfo_v2'


def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    legislator_names = legislators.map(&:name)
    legislator_names.join(", ")
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end