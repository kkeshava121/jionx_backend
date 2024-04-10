class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :role
  has_many :messages
  has_many :balance_managers
  has_many :login_logs
  has_many :modems


  def self.agents
    Role.find_by(name: "Agent").users
  end

  def self.merchants
    Role.find_by(name: "Merchant").users
  end

  def self.get_dashboard_data(current_user)
    current_role = current_user.role.try(:name)
    case current_role
    when "SuperAdmin"
        result = self.super_admin_dashboard_data(current_user)
    when "Agent"
        result = self.agent_dashboard_data(current_user)
    when "Merchant"
        result = self.merchant_dashboard_data(current_user)
    end
    result
  end

  def self.super_admin_dashboard_data(current_user)
    data = {}

    data[:total_modem] = Modem.count
    data[:total_agent] = User.agents.count

    today = Date.today
    today_transactions = BalanceManager.where.not(b_type: "Cash In").where(created_at: today.beginning_of_day..today.end_of_day, status: ["success", "approved"])
    data[:today_trx_amount] = today_transactions.sum(:amount).round(2)
    data[:today_transaction] = today_transactions.count

    total_transactions = BalanceManager.where.not(b_type: "Cash In").where(status: ["success", "approved"])
    data[:total_trx_amount] = total_transactions.sum(:amount).round(2)
    data[:total_transaction] = total_transactions.count

    data[:total_pending] = BalanceManager.where.not(b_type: "Cash In").where(status: "pending").count
    data[:total_merchant] = User.merchants.count
  
    data
  end

  def self.agent_dashboard_data(current_user)
    data = {}

    data[:total_modem] = Modem.where(user_id: current_user.id).count
  
    today = Date.today
    today_transactions = BalanceManager.where.not(b_type: "Cash In").where(created_at: today.beginning_of_day..today.end_of_day, status: ["success", "approved"], user_id: current_user.id)
    data[:today_trx_amount] = today_transactions.sum(:amount).round(2)
    data[:today_transaction] = today_transactions.count

    total_transactions = BalanceManager.where.not(b_type: "Cash In").where(status: ["success", "approved"], user_id: current_user.id)
    data[:total_trx_amount] = total_transactions.sum(:amount).round(2)
    data[:total_transaction] = total_transactions.count

    data[:total_pending] = BalanceManager.where.not(b_type: "Cash In").where(status: "pending", user_id: current_user.id).count
    data
  end

  def self.merchant_dashboard_data(current_user)
    data = {}
    data
  end

  def self.veify_pincode(options)
    result = {}
    user = User.find_by(pin_code: options[:pincode], role_id: agent_role_id)
    if user.present?
      result[:data] = user
      result[:status] = 200
      result[:message] = "Success"
    else
      result[:data] = false
      result[:status] = 404
      result[:message] = "Invalid pincode"
    end
    result
  end

  # To list of agents
  def self.get_agents(options)
    role_name = options[:role]
    parent_id = options[:parent_id].present? ? options[:parent_id] : nil
    role = Role.find_by(name: role_name)
    if role.present?
        role = Role.find_by(name: role_name)
        users = User.where(parent_id: parent_id, role_id: role.id).order(created_at: :desc)
    else
        users = []
    end
    users
  end

  def self.agent_role_id
    Role.find_by(name: "Agent").try(:id)
  end
end
