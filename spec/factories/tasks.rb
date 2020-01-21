FactoryBot.define do
  factory :task do
    title { 'テスト'}
    status { 'todo' }
    association :user
  end
end
