import UIKit

class ViewController: UIViewController {

    static let photoVCID = "PhotoViewController"

    enum Section: String, CaseIterable {
        case myAlbums = "Мои альбомы"
        case peopleAndPalace = "Люди и места"
        case jobAlbums = "Работа"
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Model>! = nil
    var photoCollectionView: UICollectionView! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Альбомы"
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .add)
        configureCollectionView()
        configureDataSource()
    }
}

extension ViewController {

    func configureCollectionView() {

        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: ViewController.photoVCID,
            withReuseIdentifier: HeaderView.headerViewID
        )
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.photoCellID)
        collectionView.register(TableCell.self, forCellWithReuseIdentifier: TableCell.reuseId)

        photoCollectionView = collectionView
    }

    func configureDataSource() {

        dataSource = UICollectionViewDiffableDataSource<Section, Model>(collectionView: photoCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, photoItem: Model) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            case .jobAlbums:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: TableCell.reuseId,
                    for: indexPath) as? TableCell
                else { fatalError("Could not create new cell") }

                cell.configure(model: photoItem)
                return cell
            default:
                guard let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: PhotoCell.photoCellID,
                    for: indexPath) as? PhotoCell
                else { fatalError("Could not create new cell") }

                cell.configure(model: photoItem)
                return cell
            }
        }

        dataSource.supplementaryViewProvider = { (collectionView: UICollectionView, kind: String, indexPath: IndexPath)
            -> UICollectionReusableView? in
            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.headerViewID, for: indexPath) as? HeaderView else { fatalError("Cannot create header view") }
            supplementaryView.label.text = Section.allCases[indexPath.section].rawValue
            return supplementaryView
        }

        let snapshot = snapshotForCurrentState()
        dataSource.apply(snapshot, animatingDifferences: false)
    }

    func generateLayout() -> UICollectionViewLayout {

        let layout = UICollectionViewCompositionalLayout { (
            sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment
        ) -> NSCollectionLayoutSection? in

            let sectionLayoutKind = Section.allCases[sectionIndex]
            switch (sectionLayoutKind) {
            case .myAlbums: return self.generateMyAlbumsLayout()
            case .peopleAndPalace: return self.generatePeopleAndPalaceAlbumsLayout()
            case .jobAlbums: return self.generateJobAlbumsLayout()
            }
        }
        return layout
    }

    func generateMyAlbumsLayout() -> NSCollectionLayoutSection {

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ViewController.photoVCID, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(CGFloat(0.5)), heightDimension: .fractionalWidth(CGFloat(1.0)))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 2)


        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func generatePeopleAndPalaceAlbumsLayout() -> NSCollectionLayoutSection {

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ViewController.photoVCID, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 5)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
    }

    func generateJobAlbumsLayout() -> NSCollectionLayoutSection {

        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: ViewController.photoVCID, alignment: .top)

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]

        return section
    }

    func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Model> {

        let myAlbums = Array(itemsForPhoto())
        let peopleAndPalaceAlbums = Array(itemsForPhoto().suffix(8).prefix(4))
        let jobAlbums = Array(itemsForPhoto().suffix(4))

        var snapshot = NSDiffableDataSourceSnapshot<Section, Model>()
        snapshot.appendSections([Section.myAlbums])
        snapshot.appendItems(myAlbums)

        snapshot.appendSections([Section.peopleAndPalace])
        snapshot.appendItems(peopleAndPalaceAlbums)

        snapshot.appendSections([Section.jobAlbums])
        snapshot.appendItems(jobAlbums)

        return snapshot
    }

    func itemsForPhoto() -> [Model] {
        return [
            Model(textLabel: "Недавние", totalNumberOfPhotos: 1320, photoName: "Pic1"),
            Model(textLabel: "Избранное", totalNumberOfPhotos: 2, photoName: "Pic2"),
            Model(textLabel: "Мой фотопоток", totalNumberOfPhotos: 100, photoName: "Pic3"),
            Model(textLabel: "WhatsApp", totalNumberOfPhotos: 44, photoName: "Pic4"),
            Model(textLabel: "Люди", totalNumberOfPhotos: 2, photoName: "Pic5"),
            Model(textLabel: "Места", totalNumberOfPhotos: 733, photoName: "Pic6"),
            Model(textLabel: "Старое", totalNumberOfPhotos: 215, photoName: "Pic7"),
            Model(textLabel: "Отдых", totalNumberOfPhotos: 243, photoName: "Pic8"),
            Model(textLabel: "КТ", totalNumberOfPhotos: 11, photoName: "Pic1"),
            Model(textLabel: "Ремонт", totalNumberOfPhotos: 100, photoName: "Pic9"),
            Model(textLabel: "Кукольный театр", totalNumberOfPhotos: 5, photoName: "Pic10"),
            Model(textLabel: "Конференция Ростов", totalNumberOfPhotos: 77, photoName: "Pic11")
        ]
    }
}
