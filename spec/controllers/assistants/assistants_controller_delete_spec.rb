require 'rails_helper'

RSpec.describe AssistantsController, type: :controller do
  let(:member) { create(:member) }

  describe 'DELETE #destroy' do
    context 'when valid assistant ID is provided' do
      it 'destroys an assistant and calls delete_assistant' do
        assistant = create(:assistant, member: member, assistant_id: 'some_id')
        
        allow_any_instance_of(OpenaiAssistant::Assistant::Client).to receive(:delete_assistant).and_return(true)

        expect do
          delete :destroy, params: { id: assistant.id }
        end.to change(Assistant, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when invalid assistant ID is provided' do
      it 'raises ActiveRecord::RecordNotFound' do
        create(:assistant, member: member)

        expect do
          delete :destroy, params: { id: 'invalid_id' }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when assistant has no assistant_id' do
      it 'destroys an assistant without calling delete_assistant' do
        assistant = create(:assistant, member: member, assistant_id: nil)
        
        expect_any_instance_of(OpenaiAssistant::Assistant::Client).not_to receive(:delete_assistant)

        expect do
          delete :destroy, params: { id: assistant.id }
        end.to change(Assistant, :count).by(-1)

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
