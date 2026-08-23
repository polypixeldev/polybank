module HcbService
  def self.get_organizations
    list = []
    page = 1

    loop do
      res = hcb_connection.get("organizations", { page:, per_page: 100 })

      if res.body.empty?
        break
      else
        list += res.body
        page += 1
      end
    end

    list
  end

  def self.get_organization(id)
    res = hcb_connection.get("organizations/#{id}")
    res.body
  end

  def self.get_organization_transactions(org_id)
    list = []
    page = 1

    loop do
      res = hcb_connection.get("organizations/#{org_id}/transactions", { page:, per_page: 100 })

      if res.body.empty?
        break
      else
        list += res.body
        page += 1
      end
    end

    list
  end

  def self.hcb_connection
    Faraday.new(url: "https://hcb.hackclub.com/api/v3") do |conn|
      conn.response :json
    end
  end
end
