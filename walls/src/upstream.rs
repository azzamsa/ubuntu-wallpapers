use std::{fs, path};

use quick_xml::de::from_str;
use serde::Deserialize;

use crate::config::Config;

#[derive(Debug, Deserialize)]
pub struct UpstreamConfig {
    #[serde(rename = "wallpaper")]
    pub wallpapers: Vec<Wallpaper>,
}

#[derive(Debug, Deserialize)]
pub struct Wallpaper {
    pub filename: Option<String>,
    #[serde(rename = "filename-dark")]
    pub filename_dark: Option<String>,
}

pub fn walls(config: &Config, codename: &str) -> anyhow::Result<Vec<String>> {
    let mut result: Vec<String> = Vec::new();

    let config = read(config, codename)?;
    for wallpaper in &config.wallpapers {
        for fname in [&wallpaper.filename, &wallpaper.filename_dark] {
            if let Some(name) = fname
                && let Some(name) = extract_name(name)? {
                    result.push(name);
                }
        }
    }

    Ok(result)
}

pub fn read(config: &Config, codename: &str) -> anyhow::Result<UpstreamConfig> {
    let path = config
        .source_path
        .join(format!("{codename}-wallpapers.xml.in"));
    let content = fs::read_to_string(path)?;
    let wallpapers: UpstreamConfig = from_str(&content)?;
    Ok(wallpapers)
}

pub fn extract_name(path: &str) -> anyhow::Result<Option<String>> {
    // Step 1: take only the filename
    let name = path::Path::new(path).file_name().unwrap().to_string_lossy();
    if !name.ends_with("xml") {
        Ok(Some(name.to_string()))
    } else {
        Ok(None)
    }
}
