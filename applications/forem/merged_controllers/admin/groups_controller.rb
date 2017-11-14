  module Admin
    class GroupsController < BaseController
      before_filter :find_group, :only => [:show, :destroy]

      def index
        @groups = Group.all
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t('forem.admin.group.index') 
 link_to t('back_to_admin', :scope => "forem.admin"), forem.admin_root_path 
 link_to t('forem.admin.group.new'), forem.new_admin_group_path, :class => "btn btn-primary" 
 t('edit', :scope => 'forem.admin.groups') 
 t('delete', :scope => 'forem.admin.groups') 
 t('name', :scope => 'forem.admin.groups') 
 @groups.each do |group| 
 link_to t('edit', :scope => 'forem.admin.groups'), forem.admin_group_path(group) 
 link_to t('delete', :scope => 'forem.admin.groups'), forem.admin_group_path(group), :method => :delete 
 link_to forem_emojify(group.name), forem.admin_group_path(group) 
 end 

end

      end

      def new
        @group = Group.new
ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.admin.group.new") 
  simple_form_for([forem, :admin, @group]) do |f| 
 f.input :name 
 f.submit :class => "btn btn-primary" 
 end 
 

end

      end

      def create
        @group = Group.new(group_params)
        if @group.save
          flash[:notice] = t("forem.admin.group.created")
          redirect_to [:admin, @group]
        else
          flash[:alert] = t("forem.admin.group.not_created")
          ruby_code_from_view.ruby_code_from_view do |rb_from_view|
 t("forem.admin.group.new") 
  simple_form_for([forem, :admin, @group]) do |f| 
 f.input :name 
 f.submit :class => "btn btn-primary" 
 end 
 

end

        end
      end

      def destroy
        @group.destroy
        flash[:notice] = t("forem.admin.group.deleted")
        redirect_to admin_groups_path
      end

      private

        def find_group
          @group = Group.find(params[:id])
        end

        def group_params
          params.require(:group).permit(:name)
        end
    end
  end
