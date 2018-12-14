
import UIKit
import CoreData

var appDelegate = UIApplication.shared.delegate as! AppDelegate

@objc(Song)
class Song: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    @NSManaged var songId: String?
    @NSManaged var songName: String?
    @NSManaged var songUrl: String?
}

var songCounter : Int = 0
//var results : NSManagedObjectContext?

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func saveData(){
        songCounter = songCounter + 1
        let entityDescription = NSEntityDescription.entity(forEntityName: "Song", in: appDelegate.managedObjectContext!)
        let newSong = NSManagedObject(entity: entityDescription!, insertInto: appDelegate.managedObjectContext) as! Song
        newSong.setValue("\(songCounter)", forKey: "songId")
        newSong.setValue("ABCD\(songCounter)", forKey: "songName")
        newSong.setValue("http://www.mySite\(songCounter).com", forKey: "songUrl")
        print("==== Save ====")
        do {
            try newSong.managedObjectContext?.save()
        } catch {
            print(error)
        }
    }

    
    func fetchData(){
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Song")
        
        do {
            let results = try appDelegate.managedObjectContext?.fetch(fetchRequest)
            
            if ((results?.count)! > 0) {
                let  songsArr = results as! [Song]
                
                for song in songsArr {
                    print(song.songId)
                    print(song.songName)
                    print(song.songUrl)
                }
            }else{
                print("No songs found")
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func deleteData(){
        //https://cocoacasts.com/how-to-delete-every-record-of-a-core-data-entity/
        
        // Initialize Fetch Request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Song")
        fetchRequest.predicate = NSPredicate.init(format: "songId==1")
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try appDelegate.managedObjectContext?.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }

    }
    
    func updateData(){
        //http://stackoverflow.com/questions/26345189/how-do-you-update-a-coredata-entry-that-has-already-been-saved-in-swift
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Song")
        fetchRequest.predicate = NSPredicate.init(format: "songId==2")
        do{
            if let fetchResults = try appDelegate.managedObjectContext!.fetch(fetchRequest) as? [NSManagedObject] {
                if fetchResults.count != 0{
                    
                    let managedObject = fetchResults[0]
                    managedObject.setValue("MySong2", forKey: "songName")
                    try appDelegate.managedObjectContext?.save()
                    
                    
                }
            }
        }catch {
            let fetchError = error as NSError
            print(fetchError)
        }
       
    }

    @IBAction func btnSaveDataClicked(_ sender: UIButton) {
        self.saveData()
    }
    
    @IBAction func btnFetchDataClicked(_ sender: UIButton) {
        self.fetchData()
    }
    
    @IBAction func btnDeleteDataClicked(_ sender: UIButton) {
        self.deleteData()
    }
    
    @IBAction func btnUpdateDataClicked(_ sender: UIButton) {
        self.updateData()
    }
}

