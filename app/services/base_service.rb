class BaseService
  attr_accessor :params, :status, :data

  def initialize(params = {})
    @params = params
    @data = nil
    @status = :ok
  end

  def call
    raise 'Not implemented'
  end

  def self.call(params = {})
    new(params).call
  end

  def returned_format(_status = nil, _data = nil)
    _status ||= status
    _data ||= _data
    {status: _status, data: _data}
  end

end