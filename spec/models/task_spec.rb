require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    it 'titleが空の場合は無効' do
      task = FactoryBot.build(:task, title: nil)
      task.valid?
      expect(task.errors[:title]).to include("can't be blank")
    end

    it '重複したタイトルの場合は無効' do
      FactoryBot.create(:task, title: 'duplicate_task')
      task = FactoryBot.build(:task, title: 'duplicate_task')
      task.valid?
      expect(task.errors[:title]).to include("has already been taken")
    end

    it 'statusが空の場合は無効' do
      task = FactoryBot.build(:task, status: nil)
      task.valid?
      expect(task.errors[:status]).to include("can't be blank")
    end
  end
end
