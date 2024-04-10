class Role < ApplicationRecord
    has_many :users
    scope :dynamic, -> { where.not(name: STATIC_ROLES) }
    validates :name, uniqueness: { message: "This Role already exist!" }


    def self.superadmin_permissions
      {
        "modules":[
            {
                "name": "Dashboard",
                "permissions": "All",
                "isEnabled": true
            },
            {
                "name": "Members",
                "permissions": [
                    {
                        "name": "Agents",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Modems",
                "permissions": [
                    {
                        "name": "Modem List",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Balance Manager",
                "permissions": [
                    {
                        "name": "All Transactions",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Success",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Pending",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Fake",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Rejected",
                        "view": true,
                        "action": true
                    },
                    {

                        "name": "Approved",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Danger",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Sms Inbox",
                "permissions": [
                    {
                        "name": "All sms",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Cash Out",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Cash In",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "B2B",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Merchants",
                "permissions": "All",
                "isEnabled": true
            }
        ]
      }
    end

    def self.agent_permissions
      {
        "modules":[
            {
                "name": "Dashboard",
                "permissions": "All",
                "isEnabled": true
            },
            {
                "name": "Members",
                "permissions": [
                    {
                        "name": "Agents",
                        "view": false,
                        "action": false
                    }
                ]
            },
            {
                "name": "Modems",
                "permissions": [
                    {
                        "name": "Modem List",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Balance Manager",
                "permissions": [
                    {
                        "name": "All Transactions",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Success",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Pending",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Fake",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Rejected",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Approved",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Danger",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Sms Inbox",
                "permissions": [
                    {
                        "name": "All sms",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Cash Out",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Cash In",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "B2B",
                        "view": true,
                        "action": true
                    }
                ]
            },
            {
                "name": "Merchants",
                "permissions": "All",
                "isEnabled": false
            }
        ]
      }
    end

    def self.merchant_permissions
      {
        "modules":[
            {
                "name": "Dashboard",
                "permissions": "All",
                "isEnabled": true
            },
            {
                "name": "Members",
                "permissions": [
                    {
                        "name": "Agents",
                        "view": false,
                        "action": false
                    }
                ]
            },
            {
                "name": "Modems",
                "permissions": [
                    {
                        "name": "Modem List",
                        "view": false,
                        "action": false
                    }
                ]
            },
            {
                "name": "Balance Manager",
                "permissions": [
                    {
                        "name": "All Transactions",
                        "view": true,
                        "action": true
                    },
                    {
                        "name": "Success",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Pending",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Fake",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Rejected",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Approved",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Danger",
                        "view": false,
                        "action": false
                    }
                ]
            },
            {
                "name": "Sms Inbox",
                "permissions": [
                    {
                        "name": "All sms",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Cash Out",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "Cash In",
                        "view": false,
                        "action": false
                    },
                    {
                        "name": "B2B",
                        "view": false,
                        "action": false
                    }
                ]
            },
            {
                "name": "Merchants",
                "permissions": "All",
                "isEnabled": false
            }
        ]
      }
    end

    def self.get_permisions_by_role(role_name='Default')
      case role_name
      when 'SuperAdmin'
          return self.superadmin_permissions
      when 'Agent'
          return self.agent_permissions
      when 'Merchant'
          return self.merchant_permissions
      end
    end
end
