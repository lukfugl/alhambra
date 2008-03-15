# table_list_url
class TableListController < ApplicationController
  def get
    @tables = {}
    Table.find(:all).each do |table|
      @tables[table_url(table)] = table
    end
    render :json => @tables.to_json
  end

  def post
    @table = Table.create(params[:table])
    render :json => @table.to_json,
      :status => :created,
      :location => @table
  end
end
