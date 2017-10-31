package it.gesp.geoportal.utils;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 */
public class ConfigUtils {

    /**
     * GEOPORTAL CONFIG
     */
    private static Properties CONFIG = null;
    private static final String CONFIG_PROPERTY_FILE_NAME = "/geoportal.properties";

    static {
        try {
            ConfigUtils.CONFIG = new Properties();
            InputStream in = ConfigUtils.class.getResourceAsStream(CONFIG_PROPERTY_FILE_NAME);
            if (in != null) {
                ConfigUtils.CONFIG.load(in);
            } else {
                System.err.println("Error config file");
            }
        } catch (IOException ex) {
            Logger.getLogger(ConfigUtils.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static Object get(String name) {
        return ConfigUtils.CONFIG.get(name);
    }

}
