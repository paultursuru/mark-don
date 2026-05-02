# Uses the markdown_render macro — no format.markdown in respond_to needed.
class ArticlesController < ApplicationController
  markdown_render only: :show

  def show
    respond_to do |format|
      format.html
    end
  end
end
