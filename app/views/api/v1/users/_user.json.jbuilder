fields = ViewFields.new params[:fields]

user_fields = fields.filter(
  %i[
    id
    login
    phone
    email
    role_code
    status_code
    first_name
    last_name
    created_at
    updated_at
    archived_at
  ]
)
json.extract! user, *user_fields
