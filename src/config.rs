use std::path::{Path, PathBuf};

pub struct Config {
    pub source_path: PathBuf,
    pub curated_path: PathBuf,
}

impl Config {
    pub fn new(source: &str, curated: &str) -> Self {
        Self {
            source_path: Path::new(source).to_path_buf(),
            curated_path: Path::new(curated).to_path_buf(),
        }
    }
}
