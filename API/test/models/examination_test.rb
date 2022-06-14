require "test_helper"

class ExaminationTest < ActiveSupport::TestCase
    test "examinations_is_not_created_without_anamnesis" do
        examination = Examination.new(user_id: 1, weight_kg: 80, height_cm: 180)

        assert_not examination.save, "Examination is created without anamnesis."
    end

    test "examinations_is_not_created_without_height_cm" do
        examination = Examination.new(user_id: 1, weight_kg: 80, anamnesis: 'OK')

        assert_not examination.save, "Examination is created without height cm."
    end

    test "examinations_is_not_created_without_weight_kg" do
        examination = Examination.new(user_id: 1, height_cm: 180, anamnesis: 'OK')

        assert_not examination.save, "Examination is created without weigh kg."
    end

    test "examinations_is_not_created_without_user_id" do
        examination = Examination.new(weight_kg: 80, height_cm: 180, anamnesis: 'OK')

        assert_not examination.save, "Examination is created without user id."
    end

    test "examinations_is_not_created_with_a_nonexistent_user_id" do
        examination = Examination.new(user_id: -1, weight_kg: 80, height_cm: 180, anamnesis: 'OK')

        assert_not examination.save, "Examination is created with a nonexistent user id."
    end

    test "examinations_is_created_with_valid_params" do
        examination = Examination.new(user_id: 1, weight_kg: 80, height_cm: 180, anamnesis: 'OK')

        assert examination.save, "Examination is not created with valid params."
    end
end