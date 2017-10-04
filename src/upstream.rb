class Upstream
  HIERARCHY = %w(makes models years engines)
  DATA_URL = 'https://mini.batteries911.com/calculadora/'

  attr_reader :item, :parent_id

  def initialize(item, parent_id)
    @item = item
    @parent_id = parent_id
  end

  def parent
    index = HIERARCHY.index(item).to_i - 1
    raise "Invalid item: #{item}" if index < 0
    HIERARCHY[index].singularize
  end

  def get_data
    parent_key = "by_vehicle_#{parent}"
    query = {'a' => item, parent_key => parent_id}
    post_upstream(query)
  end

  def post_upstream(query)
    uri = URI(DATA_URL)
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(query)
    req['x-requested-with'] = 'XMLHttpRequest'
    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    if res.code.to_i != 200 || res.content_type != 'application/json'
      raise "Error fetching data from upstream"
    end
    res.body
  end

end