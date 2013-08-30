require 'spec_helper'

describe ContactId do
  describe '#authenticate!' do
    let(:contact_id_params) do
      {
        'family_name'        => 'Stark',
        'student_number'     => 1,
        'date_of_birth(1i)' => '1995',
        'date_of_birth(2i)' => '4',
        'date_of_birth(3i)' => '1'
      }
    end

    def generate_contact_id
      ContactId.new(contact_id_params)
    end

    it 'properly parses response' do
      stub_contact_id_api [200, {}, '"758294"']

      contact_id = generate_contact_id
      contact_id.authenticate!

      contact_id.contact_id.should eq '758294'
    end

    it 'validates all the required keys are supplied' do
      expect { ContactId.find(last_name: 'Stark', dob: '10/30/2010') }.to raise_error
      expect { ContactId.find(family_name: 'Stark') }.to raise_error
    end

    it 'handles errors obtaining aspen_contact_id' do
      stub_contact_id_api [400, {}, '"758294"']

      contact_id = generate_contact_id
      contact_id.authenticate!

      contact_id.contact_id.should be_blank
      contact_id.errors.should have_key :aspen_contact_id
    end
  end
end
