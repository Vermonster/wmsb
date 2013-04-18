module DomElements
  def notifications
    find('.notifications')
  end

  def student_names_list
    find('.student-names')
  end

  def have_student_names_list
    have_css('.student-names')
  end

  def student_element(name)
    find('.student-name', text: name)
  end

  def selected_student(name)
    find('.selected-student', text: name)
  end

  def have_selected_student(name)
    have_css('.selected-student', text: name)
  end
end
