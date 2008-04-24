# table_url(:id)
class TableController < ApplicationController
  before_filter :load_table

  def get
    render :json => @table.to_json
  end

  def put
    @table.update_attributes(params[:table])
    @table.save
    render :json => @table.to_json
  end

  def delete
    @table.destroy
    head :ok
  end

  private
  def load_table
    @table = Table.find(params[:id])
  end
end
