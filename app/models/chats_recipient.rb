class ChatsRecipient < ApplicationRecord
  belongs_to :conversation
  belongs_to :chat
  belongs_to :user

  # enum read: [:no, :yes]
  # enum deleted: [:no, :yes]
end
