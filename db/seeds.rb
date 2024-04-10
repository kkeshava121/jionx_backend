# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#

#Create Company roles
STATIC_ROLES.each do |roleStr|
    permissions = Role.get_permisions_by_role(roleStr)
    role = Role.find_by(name: roleStr)
    if !role.present?
        role = Role.new(name: roleStr)
    end
    role.assign_attributes(permissions: permissions)
    role.save
    puts "Role: #{roleStr} successful"
end


["BKash", "ICICI", "Nagad", "Rockets", "Upay"].each do |name|
    bank = Bank.find_or_initialize_by(bank_name: name)
    bank.save
    puts "Bank: #{name} Created"
end

#Create super admin
role_id = Role.find_by(name: "SuperAdmin").try(:id)
user = User.find_by(role_id: role_id)
if !user.present?
    user = User.new(email: 'superadmin@example.com', full_name: 'Super Admin', pin_code: 100689, country: 'India', phone: '8077724037', user_name: 'superuser', password: 'superadmin@321', password: 'superadmin@321', password_confirmation: 'superadmin@321', role_id: role_id)
    user.save
    puts "Super Admin Created Successfully! Email:  superadmin@example.com, Password:  superadmin@321"
end