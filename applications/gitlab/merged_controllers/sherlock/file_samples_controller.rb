module Sherlock
  class FileSamplesController < Sherlock::ApplicationController
    def show
      @file_sample = @transaction.find_file_sample(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|

end

    end
  end
end
