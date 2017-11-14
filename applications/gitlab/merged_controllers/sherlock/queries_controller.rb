module Sherlock
  class QueriesController < Sherlock::ApplicationController
    def show
      @query = @transaction.find_query(params[:id])
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 page_title t('sherlock.title'), t('sherlock.transaction'), t('sherlock.query') 
 header_title t('sherlock.title'), sherlock_transactions_path 
 t('sherlock.general') 
 t('sherlock.backtrace') 
 link_to(sherlock_transaction_path(@transaction), class: 'btn') do 
 t('sherlock.transaction') 
 end 
 t('sherlock.query') 
 @query.id 
  
  t('sherlock.application_backtrace') 
 @query.application_backtrace.each do |location| 
 location.path 
 t('sherlock.line') 
 location.line 
 end 
 t('sherlock.full_backtrace') 
 @query.backtrace.each do |location| 
 if location.application? 
 location.path 
 else 
 location.path 
 end 
 t('sherlock.line') 
 location.line 
 end 
 

end

    end
  end
end
