require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  before(:each) do
    @user = create(:user)
    @other_user = create(:user)
    request.session[:user_id] = @user.id
  end

  describe "GET #edit" do
    it "returns http success" do
      get :edit, params: {id: @user.id}
      expect(response).to have_http_status(:success)
    end

    it "renders the edit template" do
      get :edit, params: {id: @user.id}
      expect(response).to render_template(:edit)
    end

    it "redirects to the root when not logged in" do
      request.session[:user_id] = nil
      get :edit, params: {id: @user.id}
      expect(response).to redirect_to root_url
    end

    it "redirects to the root when trying to delete the other user account" do
      get :edit, params: {id: @other_user.id}
      expect(response).to redirect_to root_url
    end
  end

  describe "PATCH #update" do
    it "returns http 302 Found" do
      patch :update, params: {id: @user.id, user: {save_photo: true}}
      expect(response).to have_http_status(302)
    end

    it "redirects to the edit page" do
      patch :update, params: {id: @user.id, user: {save_photo: true}}
      expect(response).to redirect_to(edit_user_path(@user))
    end

    it "redirects to the root when not logged in" do
      request.session[:user_id] = nil
      patch :update, params: {id: @user.id, user: {save_photo: true}}
      expect(response).to redirect_to root_url
    end

    it "redirects to the root when trying to delete the other user account" do
      patch :update, params: {id: @other_user.id, user: {save_photo: true}}
      expect(response).to redirect_to root_url
    end
  end

  describe "DELETE #destroy" do
    it "returns http 302 Found" do
      delete :destroy, params: {id: @user.id}
      expect(response).to have_http_status(302)
    end

    it "redirects to the root" do
      delete :destroy, params: {id: @user.id}
      expect(response).to redirect_to(root_url)
    end

    it "redirects to the root when not logged in" do
      request.session[:user_id] = nil
      delete :destroy, params: {id: @user.id}
      expect(response).to redirect_to root_url
    end

    it "redirects to the root when trying to delete the other user account" do
      delete :destroy, params: {id: @other_user.id}
      expect(response).to redirect_to root_url
    end
  end
end
