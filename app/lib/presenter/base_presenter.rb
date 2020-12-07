module Presenter
  class BasePresenter
    attr_accessor :model

    def initialize(model)
      @model = model
    end

    def to_h
      raise 'Not implemented'
    end

    alias_method :to_json, :to_h
  end
end
