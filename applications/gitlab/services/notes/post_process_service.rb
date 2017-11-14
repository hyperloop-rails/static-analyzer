module Notes
  class PostProcessService
    attr_accessor :note

    def initialize(note)
      @note = note
    end

    def execute
      # Skip system notes, like status changes and cross-references and awards
      unless @note.system || @note.is_award
        EventCreateService.new.leave_note(@note, @note.author)
        @note.create_cross_references!
        execute_note_hooks
      end
    end

    def hook_data
      Gitlab::NoteDataBuilder.build(@note, @note.author)
    end

    def execute_note_hooks
      note_data = hook_data
      @note.project.execute_hooks(note_data, :note_hooks)
      @note.project.execute_services(note_data, :note_hooks)
    end
  end
end
