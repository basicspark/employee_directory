json.array!(@users) do |user|
  json.extract! user, :id, :first_name, :last_name, :department_id, :phone, :email, :address, :start_date, :birthday
  json.url user_url(user, format: :json)
end
