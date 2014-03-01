class Web::Account::CategorySelectionsController < Web::Account::ApplicationController
  def edit
  end

  def update
    if current_user.update user_params
      redirect_to action: :edit
    else
      render 'edit'
    end
  end

private
  def user_params
    params.require(:user).permit(category_selections_attributes: [:id, :category_id, :kind, :_destroy])
  end
end
