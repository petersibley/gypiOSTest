{
    'targets': [
        {
            'target_name': 'libgyptest',
            'type': 'static_library',
            'conditions': [],
            'dependencies': [
            ],
            'sources': [
                # just automatically include all cpp and hpp files in src/ (for now)
                # '<!' is shell expand
                # '@' is to splat the arguments into list items
                # todo(kabbes) this will not work on windows
                '<!@(find src -name "*.cpp" -o -name "*.h")',
            ],
            'include_dirs': [
                'include',
            ],
            'all_dependent_settings': {
                'include_dirs': [
                    'include',
                ],
            },
        },
        {
            'target_name': 'gyptest',
            'type': 'executable',
            'dependencies': [ 'libgyptest' ],
            'libraries': [
            ],
            'sources': [
                'appsrc/main.cpp',
            ],
            'all_dependent_settings': {
                'include_dirs': [
                    'include',
                ],
            },
        },
    ],
}
