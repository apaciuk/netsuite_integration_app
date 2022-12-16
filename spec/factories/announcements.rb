# == Schema Information
#
# Table name: announcements
#
#  id                :bigint           not null, primary key
#  announcement_type :string
#  description       :text
#  name              :string
#  published_at      :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
FactoryBot.define do
  factory :announcement do
    published_at { "2022-12-16 11:20:37" }
    announcement_type { "MyString" }
    name { "MyString" }
    description { "MyText" }
  end
end
