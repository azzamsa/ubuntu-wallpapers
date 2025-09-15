use std::fs;

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize, Serialize)]
pub struct ReleaseHistory {
    pub releases: Vec<Release>,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct Release {
    pub codename: String,
    pub version: String,
    pub release_date: String,
    #[serde(default)]
    pub duplicates: Vec<String>,
}

pub fn read() -> anyhow::Result<ReleaseHistory> {
    let content = fs::read_to_string("release.ron")?;
    let release: ReleaseHistory = ron::from_str(&content)?;
    Ok(release)
}
