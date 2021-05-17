create UNIQUE index if not exists "index_files_on_component_id_and_file_path" on files (component_id, file_path);
create        index if not exists "index_files_on_fingerprint_comment_stripped_sha_256" on files (fingerprint_comment_stripped_sha_256) WHERE fingerprint_comment_stripped_sha_256 IS NOT NULL;
create        index if not exists "index_files_on_fingerprint_sha_256" on files (fingerprint_sha_256);
