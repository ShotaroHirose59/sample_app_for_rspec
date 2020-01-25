require 'rails_helper'

RSpec.describe '掲示板', type: :system do
  let(:user) { create(:user) }
  let(:other_user) {create(:user)}
  let(:task) { create(:task, user: user) }

  describe '掲示板のCRUD' do
    describe '掲示板の作成' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit new_task_path
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end
      context 'ログインしている場合' do
        before do
          login(user)
        end
        fit '掲示板が作成できること' do
          visit new_task_path
          fill_in 'Title', with: '新規作成のテスト'
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_content '新規作成のテスト'
        end
      end
    end

    describe '掲示板の更新' do
      context 'ログインしていない場合' do
        it 'ログインページにリダイレクトされること' do
          visit edit_task_path(task)
          expect(current_path).to eq login_path
          expect(page).to have_content 'Login required'
        end
      end

      context 'ログインしている場合' do
        context '自分の掲示板' do
          before do
            login(user)
            visit edit_task_path(task)
            fill_in 'Title', with: 'タスクを編集'
            click_button 'Update Task'
          end
          it '掲示板が更新できること' do
            expect(current_path).to eq task_path(task)
            expect(page).to have_content 'Task was successfully updated.'
            expect(page).to have_content 'タスクを編集'
          end
        end
      end
      context '他ユーザーのタスクの編集ページにアクセス' do
        before do
          login(other_user)
          visit edit_task_path(task)
        end
        it 'アクセスが失敗する' do
          expect(current_path).to eq root_path
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

    describe '掲示板の削除' do
      before do
        task
      end
      context '自分の掲示板' do
        before do
          login(user)
          visit tasks_path
          accept_confirm { click_link 'Destroy' }
        end
        it '掲示板が削除できること' do
          expect(current_path).to eq tasks_path
          expect(page).to have_content 'Task was successfully destroyed.'
          # タスクのタイトルが表示されていないのを確認
          expect(page).not_to have_content task.title
        end
      end
    end
  end
end
