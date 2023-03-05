# frozen_string_literal: true

Ransack.configure do |config|
  config.search_key = :query
  config.add_predicate 'jcont', arel_predicate: 'contains', formatter: proc { |v| JSON.parse(v) }
  config.custom_arrows = {
    up_arrow: '<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-narrow-up w-5 h-5" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
    <path d="M12 5l0 14"></path>
    <path d="M16 9l-4 -4"></path>
    <path d="M8 9l4 -4"></path>
    </svg>',
    down_arrow: '<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrow-narrow-down w-5 h-5" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
    <path d="M12 5l0 14"></path>
    <path d="M16 15l-4 4"></path>
    <path d="M8 15l4 4"></path>
    </svg>',
    default_arrow: '<svg xmlns="http://www.w3.org/2000/svg" class="icon icon-tabler icon-tabler-arrows-sort w-5 h-5" width="24" height="24" viewBox="0 0 24 24" stroke-width="2" stroke="currentColor" fill="none" stroke-linecap="round" stroke-linejoin="round">
    <path stroke="none" d="M0 0h24v24H0z" fill="none"></path>
    <path d="M3 9l4 -4l4 4m-4 -4v14"></path>
    <path d="M21 15l-4 4l-4 -4m4 4v-14"></path>
     </svg>'
  }
end
