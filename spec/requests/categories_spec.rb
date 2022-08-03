# frozen_string_literal: true

RSpec.describe '/categories', type: :request do
  let(:user) { create(:admin_user) }

  let(:valid_attributes) do
    { 'category_name' => 'Test Category' }
  end

  let(:invalid_attributes) do
    { 'category_name' => nil }
  end

  before :each do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Category.create! valid_attributes
      get categories_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      category = Category.create! valid_attributes
      get category_url(id: category.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_category_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      category = Category.create! valid_attributes
      get edit_category_url(id: category.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Category' do
        expect do
          post categories_url, params: { category: valid_attributes }
        end.to change(Category, :count).by(1)
      end

      it 'redirects to the created category' do
        post categories_url, params: { category: valid_attributes }
        expect(response).to redirect_to(categories_url)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Category' do
        expect do
          post categories_url, params: { category: invalid_attributes }
        end.to change(Category, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post categories_url, params: { category: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'category_name' => 'Updated Test Category' }
      end

      it 'updates the requested category' do
        category = Category.create! valid_attributes
        patch category_url(id: category.id), params: { category: new_attributes }
        category.reload
        expect(category.attributes).to include({ 'category_name' => 'Updated Test Category' })
      end

      it 'redirects to the category' do
        category = Category.create! valid_attributes
        patch category_url(id: category.id), params: { category: new_attributes }
        category.reload
        expect(response).to redirect_to(categories_url)
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        category = Category.create! valid_attributes
        patch category_url(id: category.id), params: { category: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested category' do
      category = Category.create! valid_attributes
      expect do
        delete category_url(id: category.id)
      end.to change(Category, :count).by(-1)
    end

    it 'redirects to the categories list' do
      category = Category.create! valid_attributes
      delete category_url(id: category.id)
      expect(response).to redirect_to(categories_url)
    end
  end
end
