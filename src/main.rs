mod config;
mod release;
mod upstream;

use std::env;
use std::fs;

use crate::config::Config;

fn main() -> anyhow::Result<()> {
    dotenvy::dotenv()?;

    let source_path = env::var("SOURCE")?;
    let curated_path = env::var("CURATED")?;
    let config = Config::new(&source_path, &curated_path);

    let release_history = release::read()?;
    for release in release_history.releases {
        let codename = &release.codename;
        let walls = upstream::walls(&config, codename)?;
        for wall in walls {
            fs::create_dir_all(format!("{curated_path}/{codename}"))?;
            let target = format!("{codename}/{wall}");
            copy(&config, &wall, &target)?;
        }
    }

    Ok(())
}

fn copy(config: &Config, source: &str, target: &str) -> anyhow::Result<()> {
    let path = config.source_path.join(source);
    let target = config.curated_path.join(target);
    fs::copy(path, target)?;
    Ok(())
}
