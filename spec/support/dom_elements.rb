module DomElements
  def notifications
    find('.notifications')
  end

  def have_selected_student(name)
    have_css('.selected-student', text: name)
  end
end
