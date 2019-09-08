# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Users', type: :system do
  before do
    driven_by(:rack_test)
  end

  let(:admin) { create(:testuser, :admin) }

  describe 'ユーザー削除機能' do
    context '管理者ユーザーでログインしている場合' do
      let!(:users) { create_list(:user, 9, :sample) }
      let(:displayd_user) { User.all }
      let(:destroyed_user) { User.first }

      before { valid_login(admin) }

      it 'ユーザー一覧画面でユーザーを削除する' do
        visit admin_users_path

        displayd_user.each do |user|
          expect(page).to have_link user.name, href: admin_user_path(user)

          if user == admin
            expect(page).to_not have_link '削除', href: admin_user_path(user)
          else
            expect(page).to have_link '削除', href: admin_user_path(user)
          end
        end

        expect(page).to have_content destroyed_user.name

        expect do
          click_on '削除', match: :first
        end.to change(User, :count)
        expect(current_path).to eq admin_users_path

        expect(page).to have_no_content destroyed_user.name
      end
    end
  end
end
