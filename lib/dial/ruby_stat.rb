# frozen_string_literal: true

module Dial
  module RubyStat
    private

    def ruby_vm_stat_diff before, after
      stat_diff before, after, except: [:next_shape_id]
    end

    def gc_stat_diff before, after
      stat_diff before, after, except: [
        :heap_allocatable_slots,
        :malloc_increase_bytes_limit,
        :remembered_wb_unprotected_objects_limit,
        :old_objects_limit,
        :oldmalloc_increase_bytes_limit
      ]
    end

    def gc_stat_heap_diff before, after
      after.each_with_object({}) do |(slot_index, slot_stat), diff|
        diff[slot_index] = stat_diff before[slot_index], slot_stat, except: [:slot_size]
      end
    end

    def stat_diff before, after, except: []
      after.except(*except).each_with_object({}) do |(key, value), diff|
        diff[key] = value - before[key]
      end
    end
  end
end
