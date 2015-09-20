json.array!(@library_members) do |library_member|
  json.extract! library_member, :id, :email, :name, :encrypted_password, :salt
  json.url library_member_url(library_member, format: :json)
end
