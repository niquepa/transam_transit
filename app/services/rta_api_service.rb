class RtaApiService

  def get_wo_trans(query, client_id, client_secret)
    uri = URI("https://api.rtafleet.com/graphql")

    unless check_api_key(client_id, client_secret)
      return {success: false, response: "API key not found."}
    end

    token = JSON.parse(get_token(client_id, client_secret).body)["access_token"]
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
        'Host': 'api.rtafleet.com'
    }

    req = Net::HTTP.new(uri.host, uri.port)
    req.use_ssl = true
    response = req.post(uri.path, query, headers)

    return {success: true, response: JSON.parse(response.body)}
  end

  def get_all_work_orders(tenant_id, client_id, client_secret)
    query = {'query':
             'query {
               getWorkOrderTransactions(tenantId: "' + tenant_id + '",facilityId:1,queryOptions:{filters:[]}){
                 meta{
                   totalRecords
                   totalPages
                   limit
                   offset
                   page
                 }
                 workOrderTransactions{
                   facility{
                     id
                   }
                   workOrderLine{
                     workOrder{
                       number
                     }
                     lineNumber
                   }
                   number
                   type
                   postingDate
                   quantity
                   priceWithMarkup
                   totalPriceWithMarkup
                   item{
                     ... on PartPosting{
                       part{
                         ... on NonFilePart{
                           description
                           number
                         }
                                ... on Part{
                           facility{
                             id
                           }
                           partNumber
                           description
                         }
                       }
                     }
                            ... on EmployeePosting{
                       employee{
                         ... on Employee{
                           number
                           name
                         }
                                ... on NonFileEmployee{
                           employeeNumber
                           employeeAbbreviation
                         }
                       }
                     }
                   }
                   createdBy
                 }
               }
             }',
             'variables': {}
            }
    get_wo_trans(query.to_json, client_id, client_secret)
  end

  protected

  def check_api_key(client_id, client_secret)
    if client_id && client_secret
      return true
    else
      return false
    end
  end

  private

  def get_token(client_id, client_secret)
    uri = URI("https://rtafleet.auth0.com/oauth/token")
    headers = {
        'Content-Type': 'application/x-www-form-urlencoded'
    }
    body = {
        audience: 'https://api.rtafleet.com',
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret
    }

    req = Net::HTTP::Post.new(uri)
    req['Content-Type'] = headers['Content-Type']
    req.set_form_data(body)

    response = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    return response
  end
end