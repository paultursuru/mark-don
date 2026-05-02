# Uses per-action format.markdown — the standard usage pattern.
class RoomsController < ApplicationController
  def show
    respond_to do |format|
      format.html
      format.markdown
    end
  end
end
