/**
 * Created by agnither on 02.02.14.
 */
package com.agnither.race.view {
import dragonBones.Armature;
import dragonBones.factorys.StarlingFactory;
import dragonBones.objects.ObjectDataParser;
import dragonBones.textures.StarlingTextureAtlas;

import starling.utils.AssetManager;

public class Animations {

    private static var _factory: StarlingFactory;
    public static function buildArmature(armature: String, animation: String, skeleton: String, atlas: String):Armature {
        return _factory.buildArmature(armature, animation, skeleton, atlas);
    }

    private static var _assets: AssetManager;

    public static function init(assets: AssetManager):void {
        _assets = assets;
    }

    public static function loadAnimation():void {
        _factory = new StarlingFactory();
        _factory.optimizeForRenderToTexture = false;
        _factory.generateMipMaps = false;
        _factory.addSkeletonData(ObjectDataParser.parseSkeletonData(_assets.getObject("skeleton")), "animations");
        var atlas: StarlingTextureAtlas = new StarlingTextureAtlas(_assets.getTexture("texture"), _assets.getObject("texture"), true);
        _factory.addTextureAtlas(atlas, "animations");

//        _assets.addTextureAtlas("animations", atlas);
    }

    public static function dispose():void {
        if (_factory) {
            _factory.dispose(true);
            _factory = null;
        }
    }
}
}
