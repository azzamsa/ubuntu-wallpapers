mod config;
mod release;
mod upstream;

use std::io::Write;
use std::{env, fs};

use crate::config::Config;

fn main() -> anyhow::Result<()> {
    dotenvy::dotenv()?;

    let source_path = env::var("SOURCE")?;
    let curated_path = env::var("CURATED")?;
    let config = Config::new(&source_path, &curated_path);

    fs::create_dir_all(&curated_path)?;

    let release_history = release::read()?;
    for release in release_history.releases {
        let codename = &release.codename;
        let walls = upstream::walls(&config, codename, &release.duplicates)?;

        curate(&config, codename, &walls)?;
        preview(&config, codename, &walls)?;
    }

    meta_files(&config)?;

    Ok(())
}

fn curate(config: &Config, codename: &str, wallpapers: &Vec<String>) -> anyhow::Result<()> {
    let curated_path = config.curated_path.display();

    for filename in wallpapers {
        fs::create_dir_all(format!("{curated_path}/{codename}"))?;
        let target = format!("{codename}/{filename}");
        copy(config, filename, &target)?;
    }

    Ok(())
}

fn preview(config: &Config, codename: &str, wallpapers: &Vec<String>) -> anyhow::Result<()> {
    let curated_path = config.curated_path.display();
    let mut content = String::new();

    // title
    content.push_str(&format!("# {codename}\n\n"));

    // content
    for filename in wallpapers {
        let link = &format!(
            r#"<img src="https://raw.githubusercontent.com/azzamsa/ubuntu-wallpapers/refs/heads/master/curated/{codename}/{filename}">"#
        );
        content.push_str(&format!("{link}\n\n"));
    }

    let mut file = fs::File::create(format!("{curated_path}/{codename}/README.md"))?;
    file.write_all(&content.into_bytes())?;

    Ok(())
}

/// Preserve important files
fn meta_files(config: &Config) -> anyhow::Result<()> {
    let files = ["AUTHORS", "COPYING"];

    for filename in files {
        let target = filename.to_string();
        copy(config, filename, &target)?;
    }

    Ok(())
}

fn copy(config: &Config, source: &str, target: &str) -> anyhow::Result<()> {
    let path = config.source_path.join(source);
    let target = config.curated_path.join(target);
    fs::copy(path, target)?;
    Ok(())
}
