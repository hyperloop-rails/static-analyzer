module Sherlock
  class TransactionsController < Sherlock::ApplicationController
    def index
      @transactions = Gitlab::Sherlock.collection.newest_first
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title t('sherlock.title') 
 header_title t('sherlock.title'), sherlock_transactions_path 
 link_to(destroy_all_sherlock_transactions_path,      class: 'btn btn-danger',      method: :delete) do 
 t('sherlock.delete_all_transactions') 
 end 
 t('sherlock.introduction') 
 if @transactions.empty? 
 t('sherlock.no_transactions') 
 else 
 t('sherlock.type') 
 t('sherlock.path') 
 t('sherlock.time') 
 t('sherlock.queries') 
 t('sherlock.finished_at') 
 @transactions.each do |trans| 
 trans.type 
 trans.path 
 truncate(trans.path, length: 70) 
 trans.duration.round(2) 
 t('sherlock.seconds') 
 trans.queries.length 
 time_ago_in_words(trans.finished_at) 
 t('sherlock.ago') 
 link_to(sherlock_transaction_path(trans), class: 'btn btn-xs') do 
 t('sherlock.view') 
 end 
 end 
 end 

end

    end

    def show
      @transaction = Gitlab::Sherlock.collection.find_transaction(params[:id])

      render_404 unless @transaction
    end

    def destroy_all
      Gitlab::Sherlock.collection.clear

      redirect_to(:back)
    end
  end
end
