//
//  PrimitivesScene.swift
//  Swifty Protein
//
//  Created by Kyle BAMPING on 2017/12/09.
//  Copyright © 2017 Dillon MATHER. All rights reserved.
//

import UIKit
import SceneKit

class PrimitivesScene: SCNScene {
    
    var file : [String]?
    var atoms : [SCNNode] = []
    
    init(file: [String]) {
        super.init()
        
        let sphereGeometry = SCNSphere(radius: 0.5)
        let sphereNode = SCNNode(geometry: sphereGeometry)
        self.atoms.append(sphereNode)
        
        for line in file {
            var fullNameArr = line.components(separatedBy: " ")
            fullNameArr = fullNameArr.filter { $0 != "" }
            if fullNameArr.count > 0 {
                
                if fullNameArr[0] == "ATOM" {
                    
                    let secondSphereGeometry = SCNSphere(radius: 0.3)
                    let secondSphereNode = SCNNode(geometry: secondSphereGeometry)
                    secondSphereNode.position = SCNVector3(x: Float(fullNameArr[6])!, y: Float(fullNameArr[7])!, z: Float(fullNameArr[8])!)
                    secondSphereNode.ligand.name = fullNameArr[11]
                    CPKcoloring(secondSphereGeometry, color: fullNameArr[11])
                    self.rootNode.addChildNode(secondSphereNode)
                    self.atoms.append(secondSphereNode)
                    
                } else if fullNameArr[0] == "CONECT" {
                    
                    let from : Int = Int(fullNameArr[1])!
                    let to = fullNameArr[2..<fullNameArr.count]
                    for elem in to {
                        //let line = self.lineBetweenNodeA(self.atoms[from], nodeB: self.atoms[Int(elem)!])
                        let line = self.drawConnectorBetween(vector: self.atoms[from].position, vector2: self.atoms[Int(elem)!].position)
                        self.rootNode.addChildNode(line)
                    }
                    
                }
                
            }
        }
        
    }
    
    func CPKcoloring(_ gem: SCNSphere, color: String) {
        
        switch color {
        case "H":
            gem.firstMaterial?.diffuse.contents = UIColor.white
        case "C":
            gem.firstMaterial?.diffuse.contents = UIColor.black
        case "N":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.00, green:0.14, blue:0.49, alpha:1.0)
        case "O":
            gem.firstMaterial?.diffuse.contents = UIColor.red
        case "F", "Cl":
            gem.firstMaterial?.diffuse.contents = UIColor.green
        case "Br":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.49, green:0.00, blue:0.00, alpha:1.0)
        case "I":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.37, green:0.00, blue:0.49, alpha:1.0)
        case "He", "Ne", "Ar", "Xe", "Kr":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.22, green:0.94, blue:0.99, alpha:1.0)
        case "P":
            gem.firstMaterial?.diffuse.contents = UIColor.orange
        case "S":
            gem.firstMaterial?.diffuse.contents = UIColor.yellow
        case "B":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.99, green:0.73, blue:0.51, alpha:1.0)
        case "Li", "Na", "K", "Rb", "Cs", "Fr":
            gem.firstMaterial?.diffuse.contents = UIColor.purple
        case "Be", "Mg", "Ca", "Sr", "Ba", "Ra":
            gem.firstMaterial?.diffuse.contents = UIColor(red:0.05, green:0.33, blue:0.02, alpha:1.0)
        case "Ti":
            gem.firstMaterial?.diffuse.contents = UIColor.gray
        case "Fe":
            gem.firstMaterial?.diffuse.contents = UIColor.orange
        default:
            gem.firstMaterial?.diffuse.contents = UIColor(red:1.00, green:0.00, blue:0.60, alpha:1.0)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func lineBetweenNodeA(_ nodeA: SCNNode, nodeB: SCNNode) -> SCNNode {
//        let positions: [Float32] = [nodeA.position.x, nodeA.position.y, nodeA.position.z, nodeB.position.x, nodeB.position.y, nodeB.position.z]
//        let positionData = Data(bytes: UnsafePointer(positions), count: MemoryLayout<Float32>.size*positions.count)
//        let indices: [Int32] = [0, 1]
//        let indexData = Data(bytes: UnsafePointer(indices), count: MemoryLayout<Int32>.size * indices.count)
//        
//        let source = SCNGeometrySource(data: positionData, semantic: SCNGeometrySource.Semantic.vertex, vectorCount: indices.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: MemoryLayout<Float32>.size, dataOffset: 0, dataStride: MemoryLayout<Float32>.size * 3)
//        let element = SCNGeometryElement(data: indexData, primitiveType: SCNGeometryPrimitiveType.line, primitiveCount: indices.count, bytesPerIndex: MemoryLayout<Int32>.size)
//        
//        let line = SCNGeometry(sources: [source], elements: [element])
//        line.firstMaterial?.diffuse.contents = UIColor.black
//        return SCNNode(geometry: line)
//    }
    
    func drawConnectorBetween(vector vector1: SCNVector3, vector2: SCNVector3) -> SCNNode {
        
        
        //let tmp = SCNCylinder(radius: 1.0, height: 5.0)
        //tmp.radialSegmentCount = 10
        //tmp.heightSegmentCount = 6
        
        let indices: [Int32] = [0, 1]
        
        let source = SCNGeometrySource(vertices: [vector1, vector2], count: 2)
        let element = SCNGeometryElement(indices: indices, primitiveType: SCNGeometryPrimitiveType.line)
        
        let line = SCNGeometry(sources: [source], elements: [element])
        line.firstMaterial?.diffuse.contents = UIColor.black
        
        //let tmpNode = SCNNode(geometry: tmp)
        //tmpNode.position = vector1
        //tmpNode.rotation = SCNVector4(vector2.x, vector2.y, vector2.z, 45.0)
        
        return SCNNode(geometry: line)
    }
    
}

func associatedObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}
func associateObject<ValueType: AnyObject>(
    _ base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}

class Ligand {
    var name = ""
}

private var ligandKey: UInt8 = 0

extension SCNNode {
    var ligand: Ligand {
        get {
            return associatedObject(self, key: &ligandKey)
            { return Ligand() }
        }
        set { associateObject(self, key: &ligandKey, value: newValue) }
    }
}
