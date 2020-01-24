require 'rails_helper'

RSpec.describe User, type: :system do
  let(:user) { create(:user, email: '1@example.com') }

  before do
    create(:task, title: 'タスクを表示', user: user)
  end

  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        before do
          visit sign_up_path
          fill_in 'Email', with: 'example@example.com'
          fill_in 'Password', with: '12345678'
          fill_in 'Password confirmation', with: '12345678'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成ができる' do
          expect(current_path).to eq login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        before do
          visit sign_up_path
          fill_in 'Email', with: ''
          fill_in 'Password', with: '12345678'
          fill_in 'Password confirmation', with: '12345678'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to eq '/users'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済メールアドレスを使用' do
        before do
          visit sign_up_path
          fill_in 'Email', with: '1@example.com'
          fill_in 'Password', with: '12345678'
          fill_in 'Password confirmation', with: '12345678'
          click_button 'SignUp'
        end
        it 'ユーザーの新規作成が失敗する' do
          expect(current_path).to eq users_path
          expect(page).to have_content "Email has already been taken"
        end
      end
    end
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit user_path(1)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end

  describe 'ログイン後' do
    before do
      login(user)
    end

    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        before do
          visit edit_user_path(user)
          fill_in 'Email', with: 'email@example.com'
          fill_in 'Password', with: '12345678'
          fill_in 'Password confirmation', with: '12345678'
          click_button 'Update'
        end
        it 'ユーザーの編集ができる' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'User was successfully updated.'
        end
      end
      context 'メールアドレスが未入力時に' do
        before do
          visit edit_user_path(user)
          fill_in 'Email', with: ''
          fill_in 'Password', with: '12345678'
          fill_in 'Password confirmation', with: '12345678'
          click_button 'Update'
        end
        it 'ユーザーの編集が失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end

      context '他ユーザーの編集ページにアクセス' do
        before do
          visit edit_user_path(2)
        end
        it 'アクセスが失敗する' do
          expect(current_path).to eq user_path(user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end
  end

  describe 'マイページ' do
    context 'タスクを作成' do
      before do
        login(user)
        visit user_path(user)
      end
      it '新規作成したタスクが表示される' do
        expect(page).to have_content 'タスクを表示'
      end
    end
  end
end
