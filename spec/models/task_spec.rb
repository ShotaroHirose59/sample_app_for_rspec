require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'titleが空の場合は無効' do
      task = build(:task, title: nil)
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("can't be blank")
    end

    it '重複したタイトルの場合は無効' do
      FactoryBot.create(:task, title: 'duplicate_task')
      task = build(:task, title: 'duplicate_task')
      expect(task).not_to be_valid
      expect(task.errors[:title]).to include("has already been taken")
    end

    it 'statusが空の場合は無効' do
      task = build(:task, status: nil)
      expect(task).not_to be_valid
      expect(task.errors[:status]).to include("can't be blank")
    end
  end
end
